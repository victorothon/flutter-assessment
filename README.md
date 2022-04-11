# flutter-assessment

# Flights Flutter recruitment test

Thanks for taking the time to do our Flutter coding test. The challenge has four parts:

1) A [task](#task) to consume a flights REST API.

2) A [task](#task) to list basic flights results.

3) A [task](#task) to display a detailed page of one flight result.

3) A [task](#task) to display basic information about airline results.

----

## Tasks

**REST API**

  - Fetch flight results from the provided `flights.json` (https://raw.githubusercontent.com/Skyscanner/full-stack-recruitment-test/main/public/flights.json) and save them into a SQLite database. The models created and their relationships are up to you.

**Flights List**

  - Create a screen to LIST all of the flights with at least one attribute to filter. The choice of the filter/filters is to be decided by your own criteria.

**Flight Detail**

  - Create a screen to display more detailed information about the selected flight. The choice of the information to display is up to you.

**Airlines List**

  - Create a screen to LIST all of the airlines with at least one attribute to filter. The number of flights or legs that an airline has in the received data should be displayed in the screen. The choice of the filter/filters is to be decided by your own criteria.

## Flight results

The provided (https://raw.githubusercontent.com/Skyscanner/full-stack-recruitment-test/main/public/flights.json) will return two collections of different items:

* **Itineraries** - These are the containers for your trips, tying together **Legs**, and **prices**. Prices are offered by an **agent** - an airline or travel agent.

* **Legs** - These are journeys (outbound, return) with **duration**, **stops** and **airlines**.

## Submission Guidelines

* A fork of this repository should be submitted to antonio@auxo.co with the implemented tasks in no less than 6h of the start of the assesment. However, the assesment is expected to take less than 3h. The amount of time you take to take the assesment has no effect in the results.

## Evaluation Criteria

* Your implementation works as described in the [task](#task).
* Quality of the implemented code
* Design decisions (models, UI design, relationships between entities, etc)
* Videocall to explain the implemented code to the Auxo team and answer further questions


----

Inspiration for the test format taken with ❤️ from [JustEat's recruitment test](https://github.com/justeat/JustEat.RecruitmentTest).
