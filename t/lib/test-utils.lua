local _M = {}

function _M.next_line_number()
  local info = debug.getinfo(2, 'l')
  return info.currentline + 1 -- doesn't work with whitespace
end

function _M.cmp_tables(lhs, rhs)
  local ok = true
  local got
  local expected
  local failing_k

  for k, v in pairs(lhs) do
    local rv = rhs[k]

    if v ~= rv then
      ok        = false
      failing_k = k
      got       = v
      expected  = rv
      break
    end
  end

  if ok then
    for k, v in pairs(rhs) do
      local lv = lhs[k]

      if v ~= lv then
        ok        = false
        failing_k = k
        got       = lv
        expected  = v
        break
      end
    end
  end

  if ok then
    pass()
  else
    fail 'value mismatch'
    diag(string.format('     got[%q]: %s', tostring(failing_k), tostring(got)))
    diag(string.format('expected[%q]: %s', tostring(failing_k), tostring(expected)))
  end
end

function _M.gather_results(...)
  return {
    n = select('#', ...),
    ...,
  }
end

return _M
