local Job = require('plenary.job')

Job:new({
  command = 'ls'
}):sync()
