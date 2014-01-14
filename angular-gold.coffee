#Angular Gold Modules

goldDrtv = angular.module "gold", []


###
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
###

goldDrtv.directive 'auInputName', 
    [ '$interpolate', ($interpolate) ->
        ddo = 
            restrict: 'A' # only activate on element attribute
            require: ['?ngModel', '^?form'] 
            link: ($scope, elm, attrs, ctrls)->
                #return if !ctrls # do nothing if no ctrls
                ex = $interpolate(elm.attr(attrs.$attr.auInputName));
                nameTransformed = ex($scope)
                modelCtrl = ctrls[0]
                modelCtrl.$name = nameTransformed
                elm.attr("name", nameTransformed)
                formCtrl = ctrls[1]
                formCtrl.$addControl(modelCtrl)
                return true
        return ddo        
    ]


###
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


###

goldDrtv.directive 'auFormName', 
    [ '$interpolate', ($interpolate) ->
        ddo = 
            restrict: 'A' # only activate on element attribute
            require: '?form' 
            link: ($scope, elm, attrs, ctrl)->
                #return if !ctrls # do nothing if no ctrls
                ex = $interpolate(elm.attr(attrs.$attr.auFormName));
                innerFormName = ex($scope)
                innerFormCtrl = ctrl
                formCtrl = $scope.$parent[elm.attr(attrs.$attr.auOuterForm)]
                formCtrl.$removeControl(innerFormCtrl)
                innerFormCtrl.$name = innerFormName
                elm.attr("name", innerFormName)
                formCtrl.$addControl(innerFormCtrl)
                return true
        return ddo        
    ]


### Obsolete

###
goldDrtv.directive( 'auBlur', 
    [ '$parse', ($parse) ->
        link = ($scope, elm, attrs) ->
            fn = $parse(attrs.auBlur); #attribute expression
            elm.bind('blur', (event) -> 
                $scope.$apply( () -> 
                    fn($scope, {$event: event})))
            return true
        return link
    ])

### Obsolete

###    
goldDrtv.directive('auFocus', 
    [ '$parse', ($parse) ->
        link = ($scope, elm, attrs) ->
            fn = $parse(attrs.auFocus); #attribute expression
            elm.bind('focus', (event) -> 
                $scope.$apply( () -> 
                    fn($scope, {$event: event})))
            return true
        return link
    ])

### Work in progress

###    
goldDrtv.directive('auControl', () ->
    ddo = 
        restrict: 'A' # only activate on element attribute
        require: '?ngModel' # get a hold of NgModelController pass into ctlr
        link: ($scope, elm, attrs, ngModel)->
            return if !ngModel # do nothing if no ng-model
            
            $scope.$watch(attrs.auControl, (value) ->
                attrs.$set('auControl', !!value)
                if !!value
                    elm.attr('contenteditable', '')
                else
                    elm.removeAttr('contenteditable')
            )
            # Write data to the model
            read = () -> ngModel.$setViewValue(elm.html())
            read(); # initialize
            
            #Specify how UI should be updated
            ngModel.$render = () ->
              elm.html(ngModel.$viewValue || '');
     
            # Listen for change events to enable binding
            elm.bind('blur keyup change', () -> $scope.$apply(read))
    return ddo        
    )