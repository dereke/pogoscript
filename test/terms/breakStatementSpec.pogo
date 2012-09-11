terms = require '../../src/bootstrap/codeGenerator/codeGenerator'.code generator ()
require '../assertions'
require '../codeGeneratorAssertions'

describe 'break statement'
    it 'is never implicitly returned'
        closure =
            terms.closure (
                []
                terms.statements [
                    terms.break statement ()
                ]
            )

        (closure) should contain fields (
            terms.closure (
                []
                terms.statements [
                    terms.break statement ()
                ]
                return last statement: false
            )
        )

    describe 'code generation'
        it 'generates break expression'
            break statement = terms.break statement ()

            (break statement) should generate statement 'break;'
