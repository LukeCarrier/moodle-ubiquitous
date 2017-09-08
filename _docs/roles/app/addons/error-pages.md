# Error pages

The `app-error-pages` role provides custom error pages for different HTTP statuses (e.g. 404 Not Found, 503 Service Unavailable).

## Configuration

Error pages are configured on a per-minion basis with the `app-error-pages` pillar value:

* `error-pages` specifies the list of HTTP status codes for which an nginx `error_page` should be configured. The content of the pages is declared separately.
* `translated` is a dictionary of languages (language code, e.g. `en`, to dictionary).
    * `layout` specifies a fragment of HTML used to template the error pages. This can include styling and [Server Side Include (SSI) directives](http://nginx.org/en/docs/http/ngx_http_ssi_module.html).
    * All other keys should be named after the HTTP status codes for which they'll be shown.

The following variables are declared for SSI use in error pages:

* `$platform_basename`
* `$platform_name`
* `$platform_email`
* `$platform_lang`

The error pages used for a site are configured per-platform. The following additional keys must be set:

* `name` --- the friendly name of the site, e.g. "My Moodle".
* `email` --- expected to be a support contact in the event of a technical problem.
* `lang` --- the corresponding language code used in the `app-error-pages:translated` pillar value.

For an example, see the Vagrant pillar's [`app.sls`](https://github.com/LukeCarrier/moodle-ubiquitous/blob/master/_vagrant/salt/pillar/app.sls) and [`platforms.sls`](https://github.com/LukeCarrier/moodle-ubiquitous/blob/master/_vagrant/salt/pillar/platforms.sls).
