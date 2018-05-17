<?php
declare(strict_types = 1);

namespace ASDF;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;

interface Handler
{
    public function handleRequest(Request $request): Response;
}
