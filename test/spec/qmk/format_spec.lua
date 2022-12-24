local format = require('qmk.format')

describe("greeting", function()
   it('works!', function()
      assert.combinators.match("Hello Gabo", format.greeting("Gabo"))
   end)
end)

