app = angular.module('chitter', [])

app.controller 'ChitterCtrl', ($scope, $http) ->



	$scope.hello = "testing"

	$scope.postCheet = ->
		$http.post('/cheets', {cheet: $scope.cheet}).then ->
			getCheets()


	getCheets = ->
		$http.get('/cheets').success (data) ->
			$scope.cheets = data


	getCheets()