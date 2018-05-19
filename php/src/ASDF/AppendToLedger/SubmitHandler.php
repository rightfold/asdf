<?php
declare(strict_types = 1);

namespace ASDF\AppendToLedger;

use ASDF\UseCaseHandler;

use Process\OutputBuffer;

use Symfony\Component\HttpFoundation\ParameterBag;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\StreamedResponse;

final class SubmitHandler extends UseCaseHandler
{
    public function __construct(string $buildPath)
    {
        parent::__construct(
            "$buildPath/asdf-append-to-ledger.cob.out",
            [
                'group',
                'type',
                'comment',
                'debitor',
                'creditor',
                'amount',
            ]
        );
    }

    protected function parameterBag(Request $request): ParameterBag
    {
        return $request->request;
    }

    protected function postprocess(OutputBuffer $output): Response
    {
        return new StreamedResponse(
            function() use($output): void
            {
                echo \var_export($output, \TRUE);
            }
        );
    }
}
