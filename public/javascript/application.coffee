app = angular.module('chitter', ['angularMoment'])

app.controller 'ChitterCtrl', ($scope, $http) ->

	$scope.postCheet = ->
		$http.post('/cheets', {cheet: $scope.cheet}).then ->
			getCheets()
			$scope.cheet = ""


	getCheets = ->
		$http.get('/cheets').success (data) ->
			$scope.cheets = data


	getCheets()

