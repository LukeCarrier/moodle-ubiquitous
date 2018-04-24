system:
  home_directories:
    - /home

php:
  fpm:
    global:
      pid: /run/php/php7.0-fpm.pid
      error_log: /var/log/php7.0-fpm/fpm.log

app-error-pages:
  error-pages:
    - 400
    - 401
    - 403
    - 404
    - 500
    - 502
    - 503
    - 504
  translated:
    en:
      layout: |
        <!doctype html>
        <html lang="<!--# echo var="platform_lang" -->">
          <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">

            <link href="https://fonts.googleapis.com/css?family=Roboto:300" rel="stylesheet">
            <style>
              html, body {
                height: 100%;
                margin: 0;
              }

              h1, h2, p {
                font-family: 'Roboto', sans-serif;
                font-weight: 300;
              }

              p {
                font-size: 1.1em;
                line-height: 1.5em;
              }

              a, time {
                color: #4285f4;
                font-weight: bold;
                text-decoration: none;
              }

              .outer {
                height: 100%;
                display: flex;
                flex-direction: row;
                align-items: center;
                justify-content: center;
              }

              .inner {
                max-width: 550px;
                margin: 24px;
              }

              .center {
                margin: 0 auto;
                text-align: center;
              }

              .inner h1,
              .inner h2,
              .inner p {
                text-align: center;
              }
            </style>

            <title><!--# echo var="platform_name" --></title>
          </head>
          <body>
            <div class="outer">
              <div class="inner">
                <div class="center">
                  <img src="/logo.png" alt="<!--# echo var="platform_name" --> logo">
                </div>

                {% raw %}{{ body }}{% endraw %}

                <p>If you have any questions or concerns about this please email <a href="mailto:<!--# echo var="platform_email" -->"><!--# echo var="platform_email" --></a>.</p>
              </div>
            </div>
          </body>
        </html>
      pages:
        '400': |
          <h1>We didn't quite catch that</h1>
          <h2>Error 400</h2>
          <p>Your browser sent a request we were unable to understand. Try visiting the <a href="/">dashboard</a>. If that doesn't work, try clearing your cookies.</p>
        '401': |
          <h1>Authentication is required</h1>
          <h2>Error 401</h2>
          <p>The page you requested isn't accessible to you. If you believe it should be, double check that you're signed in with the correct details.</p>
        '403': |
          <h1>Access was denied</h1>
          <h2>Error 403</h2>
          <p>The page you requested isn't accessible to you. If you believe it should be, double check that you're signed in with the correct details.</p>
        '404': |
          <h1>We couldn't find that one</h1>
          <h2>Error 404</h2>
          <p>We were unable to locate the page you requested. If you typed the address, try to reach the page from <a href="/">the dashboard</a>. If this doesn't work, we may have moved the page &mdash; please let us know.</p>
        '500': |
          <h1>Something went wrong</h1>
          <h2>Error 500</h2>
          <p>Don't panic. Something went wrong on <em>our</em> side.</p>
          <p>We might be unusually busy at the moment &mdash; try reloading the page. If this doesn't help, please wait a few minutes and try again.</p>
        '502': |
          <h1>Something went wrong</h1>
          <h2>Error 502</h2>
          <p>Don't panic. Something went wrong on <em>our</em> side.</p>
          <p>We might be unusually busy at the moment &mdash; try reloading the page. If this doesn't help, please wait a few minutes and try again.</p>
        '503': |
          <h1>Something went wrong</h1>
          <h2>Error 503</h2>
          <p>Don't panic. Something went wrong on <em>our</em> side.</p>
          <p>We might be unusually busy at the moment &mdash; try reloading the page. If this doesn't help, please wait a few minutes and try again.</p>
        '504': |
          <h1>Something's taking too long</h1>
          <h2>Error 504</h2>
          <p>Don't panic. Something went wrong on <em>our</em> side.</p>
          <p>We might be unusually busy at the moment &mdash; try reloading the page. If this doesn't help, try clearing your cookies and retrying after a few minutes.</p>
