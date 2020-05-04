# Semi-Automated Drone Swarms

You can find this code at: [https://github.com/panchbhai1969/boids](https://github.com/panchbhai1969/boids). This codebase has been forked from [https://github.com/jackaperkins/boids](https://github.com/jackaperkins/boids), it only provided a rudimentary implementation of boids. A number of additions were made to make it suitable for the current project centred to drones. The contributions include: 


|  Objective | Contributions  |
|---|---|
| 1.  | Removal of extra restriction posed.  |
| 2.  | Addition of the leader selection protocol, followers protocol and location A and B. |
| 3.  | Adding a constant source of disturbance to emulate the winds that drones may encounter.  |
| 4.  | Adding a battery element which was absent in the original implementation, and devising the strategy for scheduling refueling.|
| 5.  | Implemented the bar task as a challenge for the drones working together as a swarm, this included a seperate leader selection protocol, follower protocol and scheduling.|


## Instructions

Download processing from https://processing.org/.
Install the processing software
Open the projectCode/boids folder in the processing software as a sketch.
Run the play button on the top left corner.
Keys and corresponding operations:

|Key| Operation|
|---|---|
|q|Add drones (on clicking the mouse)|
|w|Add obstacles (on clicking the mouse)|
|e|Erase  (on clicking the mouse)|
|-|Decrease scale|
|=|Increase scale|
|1|Alignment toggle [Boids rule]|
|2|Crowd avoidance toggle [Boids rule]|
|3|Obstacle avoidance toggle [Boids rule]|
|4 |Cohesion toggle [Boids rule]|
|5|Add noise to movement of drones|
|6|Add a drone leader by birth  (on clicking the mouse)|
|s|Stop all drones|
|z|Objective 1 |
|x|Objective 2|
|c|Objective 3 (add leaders using key 6)|
|v |Objective 4 (add leaders using key 6)|
|b|Objective 5 (add leaders using key 6), see the bottom of the processing editor to see the score of the rectangle bar: A negative value leads to the rise of the rectangle bar. Bar raises only because of the leader drones.|
|,|Add walls to simulation|
|.|Add circular wall to simulation|
