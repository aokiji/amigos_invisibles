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
      fd.append "persona[#{key}]", value for key, value of item when key isnt 'restrictions'
      fd.append 'persona[avatar]', avatar if avatar?
      fd.append 'restrictions', JSON.stringify((persona.id for persona in item.restrictions))
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

class PersonaEditorController
  selected: null

  addRestriction: () ->
    this.editing.restrictions.push(this.selected)
    this.selected = null

  removeRestriction: (item) ->
    this.editing.restrictions = (persona for persona in this.editing.restrictions when persona.name isnt item.name)


app.component('personaEditor',
  templateUrl: '/web_components/persona_editor.html',
  controller: PersonaEditorController,
  bindings:
    editing: '='
    personas: '<'
    avatar: '='
)

app.filter 'notInArray', () ->
    (list, arrayFilter) ->
        return list if not arrayFilter?
        names = (item.name for item in arrayFilter)
        (item for item in list when item.name not in names)

app.filter 'removePersona', () ->
    (list, persona) ->
        return list if not persona?
        (item for item in list when item.name isnt persona.name)

app.controller("personasController", ['$scope', '$http', 'personas', ($scope, $http, personas) ->
    $scope.editing = null
    $scope.items = personas.items
    personas.getAll()

    $scope.edit = (item) ->
        $scope.editing = null
        personas.get(item.id).success((data) -> $scope.editing = data)
    $scope.save = () ->
        personas.save($scope.editing, $scope.avatar).success (saved_item) ->
          $scope.editing = null
          for item, index in $scope.items
            if item.id == saved_item.id
              $scope.items[index] = angular.copy(saved_item)
              break

])
