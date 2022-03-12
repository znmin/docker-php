<?php

require_once '/app/vendor/perftools/php-profiler/autoload.php';

try {
    $config = require '/app/config/xhprof.php';

    $profiler = new \Xhgui\Profiler\Profiler($config);
    $profiler->start();

} catch (Exception $e) {
    // throw away or log error about profiling instantiation failure
    error_log($e->getMessage());
}