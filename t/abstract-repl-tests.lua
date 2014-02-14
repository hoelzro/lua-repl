local repl = require 'repl'
pcall(require, 'luarocks.loader')
require 'Test.More'

plan(8)

do -- getprompt tests
  is(repl:getprompt(1), '>')
  is(repl:getprompt(2), '>>')
end

do -- prompt abstract tests
  error_like(function()
    repl:prompt(1)
  end, 'You must implement the showprompt method')

  error_like(function()
    repl:prompt(2)
  end, 'You must implement the showprompt method')
end

do -- name tests
  is(repl:name(), 'REPL')
end

do -- handleline abstract tests
  is(_G.testresult, nil)
  error_like(function()
    repl:handleline '_G.testresult = 17'
  end, 'You must implement the displayresults method')
  is(_G.testresult, 17)
end
