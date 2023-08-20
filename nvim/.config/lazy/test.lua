local s = string.format(
      [[git -C %s --no-pager diff --no-color --no-ext-diff -U0 -- %s]],
      vim.fn.expand('%:h'),
      vim.fn.expand('%:t')
    )


print(s)
