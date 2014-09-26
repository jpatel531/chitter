app = angular.module('chitter', ['angularMoment'])

app.controller 'ChitterCtrl', ['$scope', '$http', ($scope, $http) ->

	pusher = new Pusher('b1ea057523349531ffb6')

	channel = pusher.subscribe 'cheets'

	channel.bind 'new_cheet', (data) ->
		getCheets()

	$scope.postCheet = ->
		$http.post('/cheets', {cheet: $scope.cheet}).then ->
			$scope.cheet = ""


	getCheets = ->
		$http.get('/cheets').success (data) ->
			$scope.cheets = data


	getCheets()

]