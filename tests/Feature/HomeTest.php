<?php

use function Pest\Laravel\get;

it('should render a php layout for SPA', function () {
  get('/')->assertStatus(200);
});
