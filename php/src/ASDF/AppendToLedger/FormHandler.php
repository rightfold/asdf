<?php
declare(strict_types = 1);

namespace ASDF\AppendToLedger;

use ASDF\Handler;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\StreamedResponse;

final class FormHandler implements Handler
{
    /** @var ?FormHandler */
    private static $instance;

    private function __construct()
    {
    }

    public static function instance(): FormHandler
    {
        if (self::$instance === NULL)
        {
            self::$instance = new FormHandler();
        }
        return self::$instance;
    }

    public function handleRequest(Request $request): Response
    {
        $group = (string)$request->query->get('group');
        return new StreamedResponse(
            function() use($group): void
            {
                FormTemplate::render($group);
            }
        );
    }
}
