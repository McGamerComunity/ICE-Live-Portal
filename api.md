https://iceportal.de/api1/rs/status
```json
{
  "connection": false,
  "serviceLevel": "SERVICE_ERROR",
  "gpsStatus": "VALID",
  "internet": "OFFLINE",
  "latitude": 49.553466,
  "longitude": 10.7229143333,
  "tileY": -50,
  "tileX": 80,
  "series": "412",
  "serverTime": 1760932352247,
  "speed": 132,
  "trainType": "ICE",
  "tzn": "ICE9475",
  "wagonClass": "FIRST",
  "connectivity": {
    "currentState": "NO_INTERNET",
    "nextState": null,
    "remainingTimeSeconds": null
  },
  "bapInstalled": true
}
```

https://iceportal.de/api1/rs/tripInfo/trip
```json
{
  "trip": {
    "tripDate": "2025-10-20",
    "trainType": "ICE",
    "vzn": "888",
    "actualPosition": 149942,
    "distanceFromLastStop": 30824,
    "totalDistance": 680997,
    "stopInfo": {
      "scheduledNext": "8000260",
      "actualNext": "8000260",
      "actualLast": "8000284",
      "actualLastStarted": "8000260",
      "finalStationName": "Hamburg Hbf",
      "finalStationEvaNr": "8002549"
    },
    "stops": [
      {
        "station": {
          "evaNr": "8000261",
          "name": "München Hbf",
          "code": null,
          "geocoordinates": {
            "latitude": 48.140232,
            "longitude": 11.558335
          }
        },
        "timetable": {
          "scheduledArrivalTime": null,
          "actualArrivalTime": null,
          "showActualArrivalTime": null,
          "arrivalDelay": "",
          "scheduledDepartureTime": 1760926320000,
          "actualDepartureTime": 1760926344000,
          "showActualDepartureTime": true,
          "departureDelay": ""
        },
        "track": {
          "scheduled": "19",
          "actual": "19"
        },
        "info": {
          "status": 0,
          "passed": true,
          "positionStatus": "passed",
          "distance": 0,
          "distanceFromStart": 0
        },
        "delayReasons": null
      },
      {
        "station": {
          "evaNr": "8000183",
          "name": "Ingolstadt Hbf",
          "code": null,
          "geocoordinates": {
            "latitude": 48.744541,
            "longitude": 11.437337
          }
        },
        "timetable": {
          "scheduledArrivalTime": 1760928540000,
          "actualArrivalTime": 1760928667000,
          "showActualArrivalTime": true,
          "arrivalDelay": "+2",
          "scheduledDepartureTime": 1760928660000,
          "actualDepartureTime": 1760928797000,
          "showActualDepartureTime": true,
          "departureDelay": "+2"
        },
        "track": {
          "scheduled": "4",
          "actual": "4"
        },
        "info": {
          "status": 0,
          "passed": true,
          "positionStatus": "passed",
          "distance": 67805,
          "distanceFromStart": 67805
        },
        "delayReasons": null
      },
      {
        "station": {
          "evaNr": "8000284",
          "name": "Nürnberg Hbf",
          "code": null,
          "geocoordinates": {
            "latitude": 49.445616,
            "longitude": 11.082989
          }
        },
        "timetable": {
          "scheduledArrivalTime": 1760930520000,
          "actualArrivalTime": 1760930534000,
          "showActualArrivalTime": true,
          "arrivalDelay": "",
          "scheduledDepartureTime": 1760931120000,
          "actualDepartureTime": 1760931279000,
          "showActualDepartureTime": true,
          "departureDelay": "+2"
        },
        "track": {
          "scheduled": "6",
          "actual": "6"
        },
        "info": {
          "status": 0,
          "passed": true,
          "positionStatus": "departed",
          "distance": 82137,
          "distanceFromStart": 149942
        },
        "delayReasons": null
      },
      {
        "station": {
          "evaNr": "8000260",
          "name": "Würzburg Hbf",
          "code": null,
          "geocoordinates": {
            "latitude": 49.801796,
            "longitude": 9.93578
          }
        },
        "timetable": {
          "scheduledArrivalTime": 1760934300000,
          "actualArrivalTime": 1760934300000,
          "showActualArrivalTime": true,
          "arrivalDelay": "",
          "scheduledDepartureTime": 1760934420000,
          "actualDepartureTime": 1760934480000,
          "showActualDepartureTime": true,
          "departureDelay": "+1"
        },
        "track": {
          "scheduled": "7",
          "actual": "7"
        },
        "info": {
          "status": 0,
          "passed": false,
          "positionStatus": "future",
          "distance": 91662,
          "distanceFromStart": 241604
        },
        "delayReasons": null
      },
      {
        "station": {
          "evaNr": "8000115",
          "name": "Fulda",
          "code": null,
          "geocoordinates": {
            "latitude": 50.5549058,
            "longitude": 9.68416929
          }
        },
        "timetable": {
          "scheduledArrivalTime": 1760936460000,
          "actualArrivalTime": 1760936460000,
          "showActualArrivalTime": true,
          "arrivalDelay": "",
          "scheduledDepartureTime": 1760936580000,
          "actualDepartureTime": 1760936580000,
          "showActualDepartureTime": true,
          "departureDelay": ""
        },
        "track": {
          "scheduled": "6",
          "actual": "6"
        },
        "info": {
          "status": 0,
          "passed": false,
          "positionStatus": "future",
          "distance": 85661,
          "distanceFromStart": 327265
        },
        "delayReasons": null
      },
      {
        "station": {
          "evaNr": "8003200",
          "name": "Kassel-Wilhelmshöhe",
          "code": null,
          "geocoordinates": {
            "latitude": 51.3125585,
            "longitude": 9.44711566
          }
        },
        "timetable": {
          "scheduledArrivalTime": 1760938440000,
          "actualArrivalTime": 1760938440000,
          "showActualArrivalTime": true,
          "arrivalDelay": "",
          "scheduledDepartureTime": 1760938560000,
          "actualDepartureTime": 1760938560000,
          "showActualDepartureTime": true,
          "departureDelay": ""
        },
        "track": {
          "scheduled": "3",
          "actual": "3"
        },
        "info": {
          "status": 0,
          "passed": false,
          "positionStatus": "future",
          "distance": 85893,
          "distanceFromStart": 413158
        },
        "delayReasons": null
      },
      {
        "station": {
          "evaNr": "8000128",
          "name": "Göttingen",
          "code": null,
          "geocoordinates": {
            "latitude": 51.536815,
            "longitude": 9.926072
          }
        },
        "timetable": {
          "scheduledArrivalTime": 1760939640000,
          "actualArrivalTime": 1760939640000,
          "showActualArrivalTime": true,
          "arrivalDelay": "",
          "scheduledDepartureTime": 1760939760000,
          "actualDepartureTime": 1760939760000,
          "showActualDepartureTime": true,
          "departureDelay": ""
        },
        "track": {
          "scheduled": "9",
          "actual": "9"
        },
        "info": {
          "status": 0,
          "passed": false,
          "positionStatus": "future",
          "distance": 41540,
          "distanceFromStart": 454698
        },
        "delayReasons": null
      },
      {
        "station": {
          "evaNr": "8000152",
          "name": "Hannover Hbf",
          "code": null,
          "geocoordinates": {
            "latitude": 52.376761,
            "longitude": 9.741021
          }
        },
        "timetable": {
          "scheduledArrivalTime": 1760941920000,
          "actualArrivalTime": 1760941920000,
          "showActualArrivalTime": true,
          "arrivalDelay": "",
          "scheduledDepartureTime": 1760942160000,
          "actualDepartureTime": 1760942160000,
          "showActualDepartureTime": true,
          "departureDelay": ""
        },
        "track": {
          "scheduled": "7",
          "actual": "7"
        },
        "info": {
          "status": 0,
          "passed": false,
          "positionStatus": "future",
          "distance": 94281,
          "distanceFromStart": 548979
        },
        "delayReasons": null
      },
      {
        "station": {
          "evaNr": "8000147",
          "name": "Hamburg-Harburg",
          "code": null,
          "geocoordinates": {
            "latitude": 53.455908,
            "longitude": 9.991701
          }
        },
        "timetable": {
          "scheduledArrivalTime": 1760946060000,
          "actualArrivalTime": 1760946060000,
          "showActualArrivalTime": true,
          "arrivalDelay": "",
          "scheduledDepartureTime": 1760946180000,
          "actualDepartureTime": 1760946180000,
          "showActualDepartureTime": true,
          "departureDelay": ""
        },
        "track": {
          "scheduled": "1",
          "actual": "1"
        },
        "info": {
          "status": 0,
          "passed": false,
          "positionStatus": "future",
          "distance": 121201,
          "distanceFromStart": 670180
        },
        "delayReasons": null
      },
      {
        "station": {
          "evaNr": "8002549",
          "name": "Hamburg Hbf",
          "code": null,
          "geocoordinates": {
            "latitude": 53.552736,
            "longitude": 10.006909
          }
        },
        "timetable": {
          "scheduledArrivalTime": 1760946780000,
          "actualArrivalTime": 1760946840000,
          "showActualArrivalTime": true,
          "arrivalDelay": "+1",
          "scheduledDepartureTime": null,
          "actualDepartureTime": null,
          "showActualDepartureTime": null,
          "departureDelay": ""
        },
        "track": {
          "scheduled": "12",
          "actual": "12"
        },
        "info": {
          "status": 0,
          "passed": false,
          "positionStatus": "future",
          "distance": 10817,
          "distanceFromStart": 680997
        },
        "delayReasons": null
      }
    ]
  },
  "connection": {
    "trainType": null,
    "vzn": null,
    "trainNumber": null,
    "station": null,
    "timetable": null,
    "track": null,
    "info": null,
    "stops": null,
    "conflict": "NO_CONFLICT"
  },
  "active": null
}
```
