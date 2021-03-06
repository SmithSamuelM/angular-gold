// Generated by CoffeeScript 1.6.3
(function() {
  var goldDrtv;

  goldDrtv = angular.module("gold", []);

  /*
  au-input-name  auInputName
  
  This directive enables dynamic naming of form input controls 
  to allow dyanmic form creation
  
  This works around a problem in the angular control directives that the
  control name is a string that is not parsed so it cannot be dynamically
  generated. This causes a problem with form validation as there is no
  way to access the error state of the dynamically generated controls 
  without unique names
  
  Usage:
  
  au-input-name will set the input control name to its computed value
  
  Example:
  
  $scope.users = [ "John", "Mary"]
  
  <form>
      <div ng-repeat="user in users">
          <input type="text" au-input-name="user{{$index}}" ng-model="users[$index]">
      </div>
  </form>
  */


  goldDrtv.directive('auInputName', [
    '$interpolate', function($interpolate) {
      var ddo;
      ddo = {
        restrict: 'A',
        require: ['?ngModel', '^?form'],
        link: function($scope, elm, attrs, ctrls) {
          var ex, formCtrl, modelCtrl, nameTransformed;
          ex = $interpolate(elm.attr(attrs.$attr.auInputName));
          nameTransformed = ex($scope);
          modelCtrl = ctrls[0];
          modelCtrl.$name = nameTransformed;
          elm.attr("name", nameTransformed);
          formCtrl = ctrls[1];
          formCtrl.$addControl(modelCtrl);
          return true;
        }
      };
      return ddo;
    }
  ]);

  /*
  au-form-name auFormName
  au-outer-form auOuterForm
  
  This directive enables dynamic naming of sub forms in dynamic form creation
  
  This works around a problem in the angular form directive that the
  form name is a string that is not parsed so it cannot be dynamically
  generated. This causes a problem with form validation as there is no
  way to access the error state of the subform and its controls without a unique name
  
  Usage:
  
  au-form-name will set the form name to its computed value
  and replace it as a subform on the form with name given by ss-outer-form
  
  Example:
  $scope.users = 
  [
      first: "John"
      last: "Smith"
  ,
      first: "Mary"
      last: "Martin"
  
  ]
  <form name="orderForm">
      <div ng-repeat="user in users">
          <ng-form au-form-name="userForm{{$index}}" au-outer-form="orderForm" >
              <input type="text" name="first" placeholder="First" ng-model="user.first" >
              <input type="text" name="last" placeholder="Last"  ng-model="user.last" >
          </ng-form>
      </div
  </div>
  */


  goldDrtv.directive('auFormName', [
    '$interpolate', function($interpolate) {
      var ddo;
      ddo = {
        restrict: 'A',
        require: '?form',
        link: function($scope, elm, attrs, ctrl) {
          var ex, formCtrl, innerFormCtrl, innerFormName;
          ex = $interpolate(elm.attr(attrs.$attr.auFormName));
          innerFormName = ex($scope);
          innerFormCtrl = ctrl;
          formCtrl = $scope.$parent[elm.attr(attrs.$attr.auOuterForm)];
          formCtrl.$removeControl(innerFormCtrl);
          innerFormCtrl.$name = innerFormName;
          elm.attr("name", innerFormName);
          formCtrl.$addControl(innerFormCtrl);
          return true;
        }
      };
      return ddo;
    }
  ]);

  /* Obsolete
  */


  goldDrtv.directive('auBlur', [
    '$parse', function($parse) {
      var link;
      link = function($scope, elm, attrs) {
        var fn;
        fn = $parse(attrs.auBlur);
        elm.bind('blur', function(event) {
          return $scope.$apply(function() {
            return fn($scope, {
              $event: event
            });
          });
        });
        return true;
      };
      return link;
    }
  ]);

  /* Obsolete
  */


  goldDrtv.directive('auFocus', [
    '$parse', function($parse) {
      var link;
      link = function($scope, elm, attrs) {
        var fn;
        fn = $parse(attrs.auFocus);
        elm.bind('focus', function(event) {
          return $scope.$apply(function() {
            return fn($scope, {
              $event: event
            });
          });
        });
        return true;
      };
      return link;
    }
  ]);

  /* Work in progress
  */


  goldDrtv.directive('auControl', function() {
    var ddo;
    ddo = {
      restrict: 'A',
      require: '?ngModel',
      link: function($scope, elm, attrs, ngModel) {
        var read;
        if (!ngModel) {
          return;
        }
        $scope.$watch(attrs.auControl, function(value) {
          attrs.$set('auControl', !!value);
          if (!!value) {
            return elm.attr('contenteditable', '');
          } else {
            return elm.removeAttr('contenteditable');
          }
        });
        read = function() {
          return ngModel.$setViewValue(elm.html());
        };
        read();
        ngModel.$render = function() {
          return elm.html(ngModel.$viewValue || '');
        };
        return elm.bind('blur keyup change', function() {
          return $scope.$apply(read);
        });
      }
    };
    return ddo;
  });

}).call(this);
