// Generated by CoffeeScript 1.8.0
var app;

app = angular.module('chitter', ['angularMoment']);

app.controller('ChitterCtrl', [
  '$scope', 'http', function($scope, $http) {
    var getCheets;
    $scope.postCheet = function() {
      return $http.post('/cheets', {
        cheet: $scope.cheet
      }).then(function() {
        getCheets();
        return $scope.cheet = "";
      });
    };
    getCheets = function() {
      return $http.get('/cheets').success(function(data) {
        return $scope.cheets = data;
      });
    };
    return getCheets();
  }
]);
