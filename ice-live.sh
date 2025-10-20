#!/usr/bin/env bash
# ICE-Live Dashboard (robuste Zeitverarbeitung für Linux/macOS)
API_STATUS="https://iceportal.de/api1/rs/status"
API_TRIP="https://iceportal.de/api1/rs/tripInfo/trip"

# Helper: epoch(ms) -> HH:MM (handles GNU date and BSD date/macOS)
epoch_ms_to_hm() {
  local ms="$1"
  if [[ -z "$ms" || "$ms" == "null" ]]; then
    echo "unbekannt"
    return
  fi

  # get seconds (integer)
  local sec=$((ms / 1000))

  # try GNU date (date -d @SEC)
  if date -d "@$sec" "+%H:%M" >/dev/null 2>&1; then
    date -d "@$sec" "+%H:%M"
  # fallback macOS / BSD (date -r SEC)
  elif date -r "$sec" "+%H:%M" >/dev/null 2>&1; then
    date -r "$sec" "+%H:%M"
  else
    # ultimate fallback: print unix seconds
    echo "$sec"
  fi
}

while true; do

  status_json=$(curl -s "$API_STATUS")
  trip_json=$(curl -s "$API_TRIP")

  # Status
  speed=$(echo "$status_json" | jq -r '.speed // ""')
  lat=$(echo "$status_json" | jq -r '.latitude // ""')
  lon=$(echo "$status_json" | jq -r '.longitude // ""')
  train=$(echo "$status_json" | jq -r '.tzn // ""')
  type=$(echo "$status_json" | jq -r '.trainType // ""')
  wagon=$(echo "$status_json" | jq -r '.wagonClass // ""')
  gps_status=$(echo "$status_json" | jq -r '.gpsStatus // ""')
  internet_status=$(echo "$status_json" | jq -r '.connectivity.currentState // .internet // ""')

  # Trip
  next_station=$(echo "$trip_json" | jq -r '.trip.stopInfo.actualNext // empty')
  final_station=$(echo "$trip_json" | jq -r '.trip.stopInfo.finalStationName // ""')
  total_distance=$(echo "$trip_json" | jq -r '.trip.totalDistance // "0"')
  current_pos=$(echo "$trip_json" | jq -r '.trip.actualPosition // "0"')

  # find next stop object (if next_station empty, try scheduledNext)
  if [[ -z "$next_station" || "$next_station" == "null" ]]; then
    next_station=$(echo "$trip_json" | jq -r '.trip.stopInfo.scheduledNext // empty')
  fi

  # If still empty, pick first not-passed stop (best-effort)
  if [[ -z "$next_station" ]]; then
    next_station=$(echo "$trip_json" | jq -r '.trip.stops[] | select(.info.passed != true) | .station.evaNr' | head -n1)
  fi

  next_info=$(echo "$trip_json" | jq -r --arg eva "$next_station" '.trip.stops[] | select(.station.evaNr == $eva) // empty')
  if [[ -z "$next_info" ]]; then
    # fallback: empty object to avoid jq errors
    next_name="unbekannt"
    # Gleisnummern auslesen (geplant + tatsächlich)
    next_track_sched=$(echo "$next_info" | jq -r '.track.scheduled // ""')
    next_track_actual=$(echo "$next_info" | jq -r '.track.actual // ""')

    # Wenn beide unterschiedlich, zeig beides an
    if [[ "$next_track_sched" != "null" && "$next_track_actual" != "null" && "$next_track_sched" != "$next_track_actual" ]]; then
      track_display="${next_track_actual} (geplant: ${next_track_sched})"
    elif [[ -n "$next_track_actual" && "$next_track_actual" != "null" ]]; then
      track_display="$next_track_actual"
    elif [[ -n "$next_track_sched" && "$next_track_sched" != "null" ]]; then
      track_display="$next_track_sched"
    else
      track_display="unbekannt"
    fi
    next_sched_ms="null"
    next_actual_ms="null"
    next_distance="0"
  else
    next_name=$(echo "$next_info" | jq -r '.station.name // "unbekannt"')
    # Gleisnummern auslesen (geplant + tatsächlich)
    next_track_sched=$(echo "$next_info" | jq -r '.track.scheduled // ""')
    next_track_actual=$(echo "$next_info" | jq -r '.track.actual // ""')

    # Wenn beide unterschiedlich, zeig beides an
    if [[ "$next_track_sched" != "null" && "$next_track_actual" != "null" && "$next_track_sched" != "$next_track_actual" ]]; then
      track_display="${next_track_actual} (geplant: ${next_track_sched})"
    elif [[ -n "$next_track_actual" && "$next_track_actual" != "null" ]]; then
      track_display="$next_track_actual"
    elif [[ -n "$next_track_sched" && "$next_track_sched" != "null" ]]; then
      track_display="$next_track_sched"
    else
      track_display="unbekannt"
    fi
    # prefer scheduledArrivalTime, otherwise scheduledDepartureTime
    next_sched_ms=$(echo "$next_info" | jq -r '.timetable.scheduledArrivalTime // .timetable.scheduledDepartureTime // "null"')
    next_actual_ms=$(echo "$next_info" | jq -r '.timetable.actualArrivalTime // .timetable.actualDepartureTime // "null"')
    next_distance=$(echo "$next_info" | jq -r '.info.distanceFromStart // "0"')
  fi

  # Zeiten formatieren (HH:MM) mit Helper
  sched_time=$(epoch_ms_to_hm "$next_sched_ms")
  actual_time=$(epoch_ms_to_hm "$next_actual_ms")

  # Delay berechnen (nur wenn beide Zeiten vorhanden und numeric)
  delay_display="-"
  if [[ "$next_sched_ms" != "null" && "$next_actual_ms" != "null" ]]; then
    # ensure integers
    if [[ "$next_sched_ms" =~ ^[0-9]+$ && "$next_actual_ms" =~ ^[0-9]+$ ]]; then
      delay_min=$(((next_actual_ms - next_sched_ms) / 60000))
      if ((delay_min > 0)); then
        delay_display="+${delay_min} min"
      elif ((delay_min < 0)); then
        delay_display="${delay_min} min"
      else
        delay_display="pünktlich"
      fi
    fi
  else
    # sometimes API gives delay fields directly as strings like "+2"
    api_delay=$(echo "$next_info" | jq -r '.timetable.arrivalDelay // .timetable.departureDelay // ""')
    if [[ -n "$api_delay" && "$api_delay" != "null" ]]; then
      delay_display="$api_delay"
    fi
  fi

  # Fortschritt & Entfernungen (safe arithmetic)
  percent="0.0"
  remaining="0"
  if [[ "$total_distance" =~ ^[0-9]+$ && "$current_pos" =~ ^[0-9]+$ && "$total_distance" -gt 0 ]]; then
    percent=$(awk "BEGIN {printf \"%.1f\", ($current_pos/$total_distance)*100}")
    remaining=$((total_distance - current_pos))
    ((remaining < 0)) && remaining=0
  fi

  # Fortschrittsbalken
  bar_length=30
  filled=$(awk -v p="$percent" -v len="$bar_length" 'BEGIN {printf "%.0f", (p/100)*len}')
  ((filled < 0)) && filled=0
  ((filled > bar_length)) && filled=$bar_length
  empty=$((bar_length - filled))
  bar=$(printf "%0.s█" $(seq 1 $filled) 2>/dev/null)
  bar+=$(printf "%0.s░" $(seq 1 $empty) 2>/dev/null)

  # stops
  total_stops=$(echo "$trip_json" | jq -r '.trip.stops | length // 0')
  passed_stops=$(echo "$trip_json" | jq -r '[.trip.stops[] | select(.info.passed == true)] | length // 0')
  remaining_stops=$((total_stops - passed_stops))

  # Ausgabe
  clear
  echo -e "\033[1;36mICE-Live Dashboard\033[0m"
  echo -e "\033[36m─────────────────────────────────────────────\033[0m"
  echo -e "\033[1;33mZug:\033[0m \033[1;37m$type $train\033[0m (\033[35m$wagon\033[0m)"
  echo -e "\033[1;33mGPS:\033[0m \033[32m$gps_status\033[0m   \033[1;33mInternet:\033[0m \033[31m$internet_status\033[0m"
  echo -e "\033[1;33mGeschwindigkeit:\033[0m \033[38;5;121m${speed} km/h\033[0m"
  echo -e "\033[1;33mPosition:\033[0m \033[37mLat:\033[0m ${lat}, \033[37mLon:\033[0m ${lon}"
  echo -e "\033[1;33mFortschritt:\033[0m \033[36m[$bar]\033[0m \033[1;32m${percent}%\033[0m"
  echo -e "\033[1;33mZurückgelegt:\033[0m \033[1;37m${current_pos} m\033[0m / ${total_distance} m"
  echo -e "\033[1;33mVerbleibend:\033[0m \033[1;37m${remaining} m\033[0m"
  echo -e "\033[1;33mNächster Halt:\033[0m \033[1;36m${next_name}\033[0m (\033[37mGleis:\033[0m ${track_display})"
  echo -e "   \033[33mGeplant:\033[0m \033[37m${sched_time}\033[0m | \033[33mTatsächlich:\033[0m \033[37m${actual_time}\033[0m | \033[33mDelay:\033[0m \033[1;32m${delay_display}\033[0m"
  echo -e "\033[1;33mVerbleibende Stopps:\033[0m \033[36m${remaining_stops}\033[0m"
  echo -e "\033[1;33mEndstation:\033[0m \033[1;36m${final_station}\033[0m"
  echo -e "\033[36m─────────────────────────────────────────────\033[0m"

  echo
  echo -e "\033[1;33mFahrverlauf:\033[0m"
  echo -e "\033[36m─────────────────────────────────────────────\033[0m"

  # Stopps iterieren
  echo "$trip_json" | jq -r '.trip.stops[] |
    [
      (.station.name // "unbekannt"),
      (.info.passed // false),
      (.station.evaNr),
      (.timetable.actualArrivalTime // .timetable.scheduledArrivalTime),
      (.timetable.actualDepartureTime // .timetable.scheduledDepartureTime),
      (.track.actual // .track.scheduled // "-")
    ] | @tsv' | while IFS=$'\t' read -r name passed eva arr dep track; do

    # Farben setzen
    if [[ "$passed" == "true" ]]; then
      color="\033[32m" # grün
      status_icon=""
    elif [[ "$eva" == "$next_station" ]]; then
      color="\033[33m" # gelb
      status_icon=""
    else
      color="\033[90m" # grau
      status_icon=""
    fi

    # Zeitformatierung
    format_time() {
      local t="$1"
      if [[ "$t" == "null" || -z "$t" ]]; then
        echo "-"
      else
        local sec=$((t / 1000))
        if date -d "@$sec" "+%H:%M" >/dev/null 2>&1; then
          date -d "@$sec" "+%H:%M"
        else
          date -r "$sec" "+%H:%M"
        fi
      fi
    }

    arr_f=$(format_time "$arr")
    dep_f=$(format_time "$dep")

    # Zeile ausgeben
    if [[ "$arr_f" == "-" && "$dep_f" != "-" ]]; then
      printf "%b %s %-22s | Ab: %5s | Gl: %s\033[0m\n" "$color" "$status_icon" "$name" "$dep_f" "$track"
    elif [[ "$dep_f" == "-" && "$arr_f" != "-" ]]; then
      printf "%b %s %-22s | An: %5s | Gl: %s\033[0m\n" "$color" "$status_icon" "$name" "$arr_f" "$track"
    elif [[ "$arr_f" != "-" && "$dep_f" != "-" ]]; then
      printf "%b %s %-22s | An: %5s | Ab: %5s | Gl: %s\033[0m\n" "$color" "$status_icon" "$name" "$arr_f" "$dep_f" "$track"
    else
      printf "%b %s %-22s | Gl: %s\033[0m\n" "$color" "$status_icon" "$name" "$track"
    fi
  done

  echo -e "\033[36m─────────────────────────────────────────────\033[0m"

  echo -e "\033[2mAktualisiert: $(date +'%H:%M:%S')\033[0m"
  sleep 3
done
