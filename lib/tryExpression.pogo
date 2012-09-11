module.exports (terms) = terms.term {
    constructor (body, catch body: nil, catch parameter: nil, finally body: nil) =
        self.is try expression = true
        self.body = body
        self.catch body = catch body
        self.catch parameter = catch parameter
        self.finally body = finally body

    generate java script statement (buffer, scope, return statements) =
        buffer.write ('try{')
        if (return statements)
            self.body.generate java script statements return (buffer, scope)
        else
            self.body.generate java script statements (buffer, scope)

        buffer.write ('}')
        if (self.catch body)
            buffer.write ('catch(')
            self.catch parameter.generate java script (buffer, scope)
            buffer.write ('){')
            if (return statements)
                self.catch body.generate java script statements return (buffer, scope)
            else
                self.catch body.generate java script statements (buffer, scope)

            buffer.write ('}')

        if (self.finally body)
            buffer.write ('finally{')
            self.finally body.generate java script statements (buffer, scope)
            buffer.write ('}')
    
    generate java script (buffer, symbol scope) =
        if (self.already called)
            throw (new (Error 'stuff'))

        self.already called = true
        self.cg.scope ([self], always generate function: true).generate java script (buffer, symbol scope)

    rewrite result term into (return term) =
        self.body.rewrite result term into (return term)

        if (self.catch body)
            self.catch body.rewrite result term into (return term)

        self
}
