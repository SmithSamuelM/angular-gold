


#Example usage


```html
    
    <!doctype html>
    <html ng-app="japn">
      <head>
        
        <link rel="stylesheet" href="/japn/static/libs/bootstrap/css/bootstrap.css">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="/japn/static/libs/bootstrap/css/bootstrap-responsive.css" rel="stylesheet">
        <!--<script src="/japn/static/libs/bootstrap/js/bootstrap.js"></script>-->
    
        <script src="/japn/static/libs/angular/angular.js"></script>
        <script src="/japn/static/libs/angular-strap/angular-gold.js"></script>
        
        <script src="/japn/static/files/demo.js"></script>
        
      </head>
      <body ng-init="basePath='/japn'">
         <div au-control="fooeditable" ng-model="foo" name="foo">Fantastic</div>
         <p>{{foo}}</p>
         <label>
           <input type="checkbox" name="editable" value="false" ng-model="fooeditable">
           Editable
         </label>
    
         <p>$scope.test = {{test}} </p>
         <p>$scope.burp = {{burp}} </p>
    
         <label>Burp<br/>
          <input type="text" name='burp' ng-model='burp'
          au-blur="test=burp;" au-focus="test=burp">
      </body>
    </html>
    
   
    
```
```javascript
   demo = angular.module("demo", ['gold']);

```
