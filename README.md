#Chitter

Creating a Twitter clone as part of our Week 6 Friday Test at Makers Academy. An exercise in getting more acquainted with Sinatra, DataMapper and BCrypt. As an extension, I decided to use the Grape gem to create a small API of Cheets, which AngularJS processes asynchronously.

##Objectives

* To practise secure user-management in Sinatra.
* To learn more about DataMapper.
* To learn about the Grape and GrapeEntity gems.
* To practise front-end form-validations with AngularJS, combined with back-end validations with DataMapper

##Heroku

[Here is a link to Chitter on Heroku.](http://chiiitter.herokuapp.com)

![Image1](https://raw.githubusercontent.com/jpatel531/chitter/master/screenshot.jpg)

##Technologies

* Ruby
* Sinatra
* Cucumber and Capybara for integration tests
* RSpec for unit tests
* Grape and GrapeEntity
* AngularJS
* BCrypt
* DataMapper
* MomentJS and AngularMoment
* Bootstrap

##How to run

```
git clone https://github.com/jpatel531/chitter.git
cd chitter
shotgun
```

##How to run end-to-end tests

```
cucumber
```

##How to run unit tests

```
rspec
```

##Planned Extensions

* Replying to Cheets