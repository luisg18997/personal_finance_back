module.exports = {
    apps : [{
      name        : "personal-finance-back",
      script      : "./src/index.js",
      watch: true,
        kill_timeout: 10000,
        wait_ready: true
    }]
  }
