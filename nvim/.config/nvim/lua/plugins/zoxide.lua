return {
  "alfaix/nvim-zoxide",
  cmd = { "Z", "Zi" },
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    define_commands = true,
    path = "zoxide",
  },
  config = function(_, opts)
    local zoxide = require("zoxide")
    zoxide.setup(opts)

    -- Workaround for https://github.com/alfaix/nvim-zoxide/issues/1
    -- vim.notify calls in on_exit run in a fast event context and must be scheduled
    local Job = require("plenary.job")
    zoxide.zoxide = function(context, callback)
      if callback == nil then
        callback = zoxide.cd
      end
      Job:new({
        command = zoxide.get_config().path,
        args = context.mode == "list"
          and { "query", "--list", context.query }
          or { "query", context.query },
        on_exit = function(j, return_val)
          if return_val ~= 0 then
            vim.schedule(function()
              vim.notify("Zoxide failed: stderr=" .. table.concat(j:stderr_result()), vim.log.levels.WARN)
              callback(context, nil)
            end)
            return
          end
          local stdout = j:result()
          if #stdout == 0 then
            vim.schedule(function()
              vim.notify("Zoxide failed: no matches found", vim.log.levels.WARN)
              callback(context, nil)
            end)
          else
            local function select_result(results)
              local cd_command_name = ({ global = "cd", tab = "tcd", window = "lcd" })[context.scope]
              if context.mode == "list" and #results ~= 1 then
                vim.schedule(function()
                  vim.ui.select(results, { prompt = string.format(":%s to...", cd_command_name) }, function(dir)
                    vim.schedule(function() callback(context, dir) end)
                  end)
                end)
              else
                vim.schedule(function() callback(context, results[1]) end)
              end
            end
            select_result(stdout)
          end
        end,
      }):start()
    end
  end,
}
