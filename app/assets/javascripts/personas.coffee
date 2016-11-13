# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
app = angular.module("amigosInvisibles", []);
app.factory('personas', ['$http', ($http) ->
  service = 
    items: []
    getAll: () ->
      $http.get('/personas.json').success((data) -> angular.copy(data, service.items))
    get: (id) ->
      $http.get("/personas/#{id}.json")
    save: (item, avatar) ->
      fd = new FormData
      fd.append 'persona[avatar]', avatar if avatar?
      fd.append "persona[#{key}]", value for key, value of item
      $http.patch("/personas/#{item.id}", fd, 
        headers: {'Content-type': undefined}
        transformRequest: angular.identity
      )
])

app.directive('fileInput', ['$parse', ($parse) ->
  restrict: 'A'
  link: (scope, elm, attrs) ->
    elm.bind 'change', () ->
      $parse(attrs.fileInput).assign(scope, elm[0].files[0])
      scope.$apply()
])

app.controller("personasController", ['$scope', '$http', 'personas', ($scope, $http, personas) -> 
    $scope.editing = null
    $scope.items = personas.items
    personas.getAll()

    $scope.edit = (item) ->
        $scope.editing = null
        $scope.avatar = null
        personas.get(item.id).success((data) -> $scope.editing = data)
    $scope.save = () ->
        personas.save($scope.editing, $scope.avatar).success(() -> $scope.editing = null)
])
