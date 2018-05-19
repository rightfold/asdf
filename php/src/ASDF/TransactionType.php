<?php
declare(strict_types = 1);

namespace ASDF;

final class TransactionType
{
    private function __construct()
    {
    }

    public const PAYMENT = 'P';
    public const DEBT    = 'D';
}
