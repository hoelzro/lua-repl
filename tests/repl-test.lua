local repl = require 'repl'

context('REPL tests', function()
  context('abstract REPL tests', function()
    test('getprompt tests', function()
      assert_equal('lua>', repl:getprompt(1))
      assert_equal('lua>>', repl:getprompt(2))
    end)

    test('prompt abstract tests', function()
      assert_error(function()
        repl:prompt(1)
      end)

      assert_error(function()
        repl:prompt(2)
      end)
    end)

    test('REPL name tests', function()
      assert_equal('REPL', repl:name())
    end)

    test('evaluate abstract tests', function()
      assert_nil(_G.testresult)
      assert_error(function()
        repl:evaluate '_G.testresult = 17'
      end)
      assert_equal(_G.testresult, 17)
    end)
  end)

  context('clone REPL tests', function()
    local clone
    local prompt
    local results

    test('clone tests', function()
      clone = repl:clone()
      assert_not_nil(clone)

      function clone:showprompt(p)
        prompt = p
      end

      function clone:displayresults(r)
        results = r
      end
    end)

    test('prompt tests', function()
      assert_not_error(function()
        clone:prompt(1)
      end)
      assert_equal('lua>', prompt)

      assert_not_error(function()
        clone:prompt(2)
      end)
      assert_equal('lua>>', prompt)
    end)

    test('evaluate tests', function()
      assert_equal(_G.testresult, 17)
      assert_nil(results)
      assert_not_error(function()
        clone:evaluate '_G.testresult = 18'
      end)
      assert_equal(_G.testresult, 18)

      assert_type(results, 'table')
      assert_equal(results.n, 0)
      assert_equal(#results, 0)

      assert_not_error(function()
        clone:evaluate 'return 19'
      end)

      assert_type(results, 'table')
      assert_equal(results.n, 1)
      assert_equal(#results, 1)
      assert_equal(results[1], 19)

      assert_not_error(function()
        clone:evaluate 'return 20, 21, 22'
      end)

      assert_type(results, 'table')
      assert_equal(results.n, 3)
      assert_equal(#results, 3)
      assert_equal(results[1], 20)
      assert_equal(results[2], 21)
      assert_equal(results[3], 22)

      assert_not_error(function()
        clone:evaluate 'return 1, nil, nil, nil, nil, nil, nil, 2'
      end)

      assert_type(results, 'table')
      assert_equal(results.n, 8)
      assert_equal(results[1], 1)
      for i = 2, 7 do
        assert_nil(results[i])
      end
      assert_equal(results[8], 2)
    end)

    test('error handling tests', function()
      assert_not_error(function()
        clone:evaluate '3 4'
      end)

      assert_not_nil(errmsg)

      errmsg = nil

      assert_not_error(function()
        clone:evaluate 'error "foo"'
      end)

      assert_not_nil(errmsg)
    end)
  end)

  context('sync REPL tests', function()
    local sync       = require 'repl.sync'
    local clone      = sync:clone()
    local resultlist = {}

    function clone:lines()
      local index = 0
      local function iterator(s)
        index = index + 1
        return s[index]
      end

      return iterator, {
        'foo',
        '1',
        '"bar"',
        '{}',
        '1, 2, 3',
      }
    end

    function clone:showprompt()
    end

    function clone:displayresults(results)
      resultlist[#resultlist + 1] = results
    end

    test('sync REPL tests', function()
      clone:run()

      assert_equal(#resultlist, 5)

      assert_equal(resultlist[1].n, 1)
      assert_nil(resultlist[1][1])

      assert_equal(resultlist[2].n, 1)
      assert_equal(resultlist[2][1], 1)

      assert_equal(resultlist[3].n, 1)
      assert_equal(resultlist[3][1], 'bar')

      assert_equal(resultlist[4].n, 1)
      assert_type(resultlist[4][1], 'table')

      assert_equal(resultlist[5].n, 3)
      assert_equal(resultlist[5][1], 1)
      assert_equal(resultlist[5][2], 2)
      assert_equal(resultlist[5][3], 3)
    end)
  end)
end)
