<?php
declare(strict_types = 1);

namespace ASDF\ListLedger;

use ASDF\TransactionType;

final class Template {
    private function __construct()
    {
    }

    /**
     * @param iterable<int,array<string>> $transactions
     */
    public static function render(iterable $transactions): void
    {
        ?>
            <table>
                <tbody>
                    <?php foreach ($transactions as list($id, $type, $timestamp, $comment, $debitor, $creditor, $amount)): ?>
                        <tr>
                            <td><?php echo \htmlentities($id); ?></td>
                            <td>
                                <?php if ($type === TransactionType::PAYMENT): ?>
                                    Payment
                                <?php endif; ?>
                                <?php if ($type === TransactionType::DEBT): ?>
                                    Debt
                                <?php endif; ?>
                            </td>
                            <td><?php echo \htmlentities($timestamp); ?></td>
                            <td><?php echo \htmlentities($comment); ?></td>
                            <td><?php echo \htmlentities($debitor); ?></td>
                            <td><?php echo \htmlentities($creditor); ?></td>
                            <td><?php echo \htmlentities($amount); ?></td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        <?php
    }
}
