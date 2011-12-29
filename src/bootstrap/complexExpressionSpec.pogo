require 'cupoftea'
cg = require './codeGenerator/codeGenerator'
require './assertions.pogo'

int @n =
  cg: integer @n

id @name = cg: identifier @name

variable @name = cg: variable [name]

parameter @name = cg: parameter [name]

block = cg: block [] (cg: statements [variable 'x'])

no arg punctuation = cg: no arg suffix?

expression @e should contain fields @f =
  (cg: complex expression @e: expression?) should contain fields @f

spec 'complex expression'
  spec 'has arguments'
    expression @e should have arguments =
      (cg: complex expression @e: has arguments?) should be truthy
    
    spec 'with arguments in head'
      expression [[id 'a'. int 10]] should have arguments

  spec 'expression'
    spec 'with just one argument is that argument'
      expression [[int 9]] should contain fields #
        is integer
        integer 9

    spec 'with name is variable'
      expression [[id 'a'. id 'variable']] should contain fields #
        is variable
        variable ['a'. 'variable']

    spec 'with name and argument is function call'
      expression [[id 'a'. id 'variable'. int 10]] should contain fields #
        is function call
        function #{is variable. variable ['a'. 'variable']}
        arguments [#{integer 10}]

    spec 'finds macro'
      expression [[id 'if'. variable. block]] should contain fields #
        is if expression

    spec 'with name and optional args is function call with optional args'
      expression [[id 'a'. id 'variable']. [id 'port'. int 80]] should contain fields #
        is function call
        function #{is variable. variable ['a'. 'variable']}
        arguments []
        optional arguments [#{field ['port'], value #{integer 80}}]

  spec 'object operation -> expression'
    expression @object @operation should contain fields @fields =
      (cg: complex expression @operation: object operation @object: expression?) should contain fields @fields
  
    spec 'method call'
      expression (variable 'a') [[id 'method'. int 10]] should contain fields #
        is method call
        object #{variable ['a']}
        name ['method']
        arguments [#{integer 10}]
  
    spec 'method call with optional arguments'
      expression (variable 'a') [[id 'method'. int 10]. [id 'port'. int 80]] should contain fields #
        is method call
        object #{variable ['a']}
        name ['method']
        arguments [#{integer 10}]
        optional arguments [#{field ['port'], value #{integer 80}}]

    spec 'index'
      expression (variable 'a') [[int 10]] should contain fields #
        is indexer
        object #{variable ['a']}
        indexer #{integer 10}

    spec 'field reference'
      expression (variable 'a') [[id 'field']] should contain fields #
        is field reference
        object #{variable ['a']}
        name ['field']

  spec 'object operation -> definition'
    definition @object @operation @source should contain fields @fields =
      (cg: complex expression @operation: object operation @object: definition @source) should contain fields @fields
    
    spec 'method definition'
      definition (variable 'object') [[id 'method'. variable 'x']] @block should contain fields #
        is definition
        target #
          is field reference
          name ['method']
          object #{variable ['object']}
        
        source #
          is block
          parameters [#{parameter ['x']}]
    
    spec 'method definition without block'
      definition (variable 'object') [[id 'method'. variable 'x']] (variable 'y') should contain fields #
        is definition
        target #
          is field reference
          name ['method']
          object #{variable ['object']}
        
        source #
          is block
          redefines self
          parameters [#{parameter ['x']}]
          body #{statements [#{variable ['y']}]}
    
    spec 'field definition'
      definition (variable 'object') [[id 'x']] (variable 'y') should contain fields #
        is definition
        target #
          is field reference
          name ['x']
          object #{variable ['object']}
        
        source #
          is variable
          variable ['y']
    
    spec 'index definition'
      definition (variable 'object') [[variable 'x']] (variable 'y') should contain fields #
        is definition
        target #
          is indexer
          indexer #{variable ['x']}
          object #{variable ['object']}
        
        source #
          is variable
          variable ['y']

  spec 'definition'
    definition @target @source should contain fields @fields =
      (cg: complex expression @target: definition @source) should contain fields @fields
    
    spec 'function definition'
      definition [[id 'function'. variable 'x']] @block should contain fields #
        is definition
        target #
          is variable
          variable ['function']
        
        source #
          is block
          parameters [#{parameter ['x']}]
          body #{statements [#{variable ['x']}]}
    
    spec 'function definition with optional parameter'
      definition [[id 'function'. variable 'x']. [id 'port'. int 80]. [id 'name']] (variable 'y') should contain fields #
        is definition
        target #
          is variable
          variable ['function']
        
        source #
          is block
          parameters [#{parameter ['x']}]
          optional parameters [
            #{field ['port'], value #{integer 80}}
            #{field ['name'], value @undefined}
          ]
          body #{statements [#{variable ['y']}]}
    
    spec 'function definition without block'
      definition [[id 'function'. variable 'x']] (variable 'y') should contain fields #
        is definition
        target #
          is variable
          variable ['function']
        
        source #
          is block
          parameters [#{parameter ['x']}]
          body #{statements [#{variable ['y']}]}
    
    spec 'no arg function definition'
      definition [[id 'function'. no arg punctuation]] (variable 'y') should contain fields #
        is definition
        target #
          is variable
          variable ['function']
        
        source #
          is block
          parameters []
          body #{statements [#{variable ['y']}]}
    
    spec 'variable definition'
      definition [[id 'function']] (variable 'y') should contain fields #
        is definition
        target #
          is variable
          variable ['function']
        
        source #
          is variable
          variable ['y']

    spec 'variable definition with scope'
      definition [[id 'function']] (cg: block [] (cg: statements [variable 'y'])) should contain fields #
        is definition
        target #
          is variable
          variable ['function']
        
        source #
          is function call
          function #
            is block
            parameters []
            body #
                statements [#{variable ['y']}]
        
          arguments []

    spec 'parameter'
        parameter @p should contain fields @fields =
            (cg: complex expression @p: parameter?) should contain fields @fields
        
        spec 'variable'
            parameter [[id 'a']] should contain fields #
                is parameter
                parameter ['a']