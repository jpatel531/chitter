// Generated by CoffeeScript 1.8.0
var app;

app = angular.module('chitter', []);

app.controller('ChitterCtrl', function($scope, $http) {
  $scope.hello = "testing";
  return $scope.postCheet = function() {
    return $http.post('/cheets', {
      cheet: $scope.cheet
    });
  };
});
