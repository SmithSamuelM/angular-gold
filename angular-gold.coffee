#Angular Gold Modules

angular.module( "gold", []).
directive( 'auBlur', 
    [ '$parse', ($parse) ->
        link = ($scope, elm, attrs) ->
            fn = $parse(attrs.auBlur); #attribute expression
            elm.bind('blur', (event) -> 
                $scope.$apply( () -> 
                    fn($scope, {$event: event})))
            return true
        return link
    ]).
directive('auFocus', 
    [ '$parse', ($parse) ->
        link = ($scope, elm, attrs) ->
            fn = $parse(attrs.auFocus); #attribute expression
            elm.bind('focus', (event) -> 
                $scope.$apply( () -> 
                    fn($scope, {$event: event})))
            return true
        return link
    ]).
directive('auControl', () ->
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
    ).
directive('auInputName', 
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
                elm.attr("name",nameTransformed)
                formCtrl = ctrls[1]
                formCtrl.$addControl(modelCtrl)
                return true
        return ddo        
    ]).
directive('auFormName', 
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
                elm.attr("name",innerFormName)
                formCtrl.$addControl(innerFormCtrl)
                return true
        return ddo        
    ])

