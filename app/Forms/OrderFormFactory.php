<?php

declare(strict_types=1);

namespace App\Forms;

use Nette\Application\UI\Form;

class OrderFormFactory
{
    public function create(): Form
    {
        $form = new Form;
        $form->addEmail('email', 'E-mail:')
            ->setRequired('Please enter an email address');
        $form->addText('fullname', 'Full name:')
            ->addRule($form::Pattern, 'Please enter your full name', '.{3,}')
            ->setRequired('Please enter your full name');
        $form->addText('phone', 'Phone:')
            ->addRule($form::Pattern, 'Please enter a phone number', '[\d /*+-]{9,}')
            ->setRequired('Please enter a phone number');
        $form->addSubmit('send', 'Place Order');

        return $form;
    }
}
