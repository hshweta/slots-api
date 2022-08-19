# README
This a Ruby on Rails APIs application developed as a part of an assignment. This application helps user in slots creation.

Problem Definition:
Create a REST API using ROR application which will allow the users to
create time based slots. That should accepts various parameters in
payload: start_time, end_time, and total_capacity.

Divide all the capacities during the entered start and end time. And if
some capacities are exceeding the rounding values then divide the slot
capacities to the last slots.


* Ruby version
    2.7.2

* Rails version
    5.0.7.2

* System dependencies
    (PostgreSQL) 12.11

* Configuration
    bundle install

* Database creation
    rake db:setup

* Database initialization
    rake db:migrate

* Supported APIs are:

To get all the slots
GET    /slots(.:format)
e.g. GET http://localhost:3000/slots

To get a particular slot
GET    /slots/:id(.:format)
e.g. GET http://localhost:3000/slots/1

To create a slot
POST   /slots(.:format)
e.g. POST http://localhost:3000/slots?slot[total_capacity]=6&slot[start_time]=2022-08-20 11:00:00&slot[end_time]=2022-08-20 12:00:00

To delete a particular slot
DELETE /slots/:id(.:format)
e.g. DELETE http://localhost:3000/slots/1

* To run unit tests for Slot model
rails test test/models/slot_test.rb

* Things out of scope
    * Since this is a standalone application, did not consider API versioning and caching.
    * User Authentication and authorization is not supported.
    * Update API is also not supported. If user wants to change some slot, it can be done by first deleting the slot and create a new one.