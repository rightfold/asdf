<?php
declare(strict_types = 1);

namespace ASDF;

final class MasterTemplate
{
    private function __construct()
    {
    }

    public static function renderHeader(string $title): void
    {
        ?>
            <!DOCTYPE html>
            <html>
                <head>
                    <meta charset="utf-8">
                    <title>ASDF / <?php echo \htmlentities($title); ?></title>
                    <link rel="stylesheet" href="/static/application.css">
                </head>
                <body>
                    <header class="asdf--header">
                        ASDF / <?php echo \htmlentities($title); ?>
                    </header>
                    <section class="asdf--content">
        <?php
    }

    public static function renderFooter(): void
    {
        ?>
                    </section>
                    <footer class="asdf--footer">
                        Footer
                    </footer>
                </body>
            </html>
        <?php
    }
}
