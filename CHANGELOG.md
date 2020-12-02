Workarea Kount 3.3.1 (2020-12-02)
--------------------------------------------------------------------------------

*   Improve current order decoration for compatibility with other plugins

    Using `super` ensures other decorations to this method will still
    be incorporated.

    Ben Crouse



Workarea Kount 3.3.0 (2020-09-25)
--------------------------------------------------------------------------------

*   Refactor To Use Fraud Decision Framework

    Workarea v3.5 introduced a new "fraud decision" API that allows any
    integration plugin to consistently provide information on fraudulent
    orders. To take advantage of this API, the Kount plugin renamed its
    `Kount::OrderFraudService` to `Checkout::Fraud::KountAnalyzer` and now
    configures this analyzer by default when installing the plugin. This
    way, after installing and configuring the Kount plugin, you will
    automatically link Kount in with the rest of the fraud decision
    framework that is built in core. This commit also takes care of the test
    suite as there were a number of failures when combining with other
    plugins.

    KOUNT-2
    KOUNT-3
    Fixes #1

    Tom Scott



Workarea Kount 3.2.3 (2019-09-17)
--------------------------------------------------------------------------------

*   Update `Order.find_current` to exlucde orders under kount review

    Prevent orders that are placed under review from Kount's fraud decision
    from being edited as carts

    KOUNT-41
    Eric Pigeon



Workarea Kount 3.2.2 (2019-05-28)
--------------------------------------------------------------------------------

*   Set PTYP to TOKEN for saved credit cards

    KOUNT-40
    Eric Pigeon



Workarea Kount 3.2.1 (2019-05-14)
--------------------------------------------------------------------------------

*   Prevent order confirmation emails being sent for orders in kount review

    * Disable order reminders for any order with a kount status.
    * Decorate payment_test to include an order and use the order's ID for payment

    KOUNT-39
    Jake Beresford



Workarea Kount 3.2.0 (2019-04-30)
--------------------------------------------------------------------------------

*   Kount admin improvements

    * Index orders declined by Kount in the admin
    * Display kount decision in the admin
    * Add payment status calculator for kount review and kount declined

    KOUNT-38
    Jake Beresford

*   README Improvements

    * Add `kount_site` configuration instructions
    * Clarify ENS integration
    * Fix spelling and grammar

    KOUNT-36
    Jake Beresford



Workarea Kount 3.1.1 (2019-03-19)
--------------------------------------------------------------------------------

*   Fix rubocop error

    KOUNT-34
    Jake Beresford

*   Add safe navigation to .success method for Admin::OrderViewModel#kount_order_success?

    KOUNT-34
    Jake Beresford

*   Update CI scripts for v3.4 compatibility

    KOUNT-34
    Jake Beresford



Workarea Kount 3.1.0 (2019-01-22)
--------------------------------------------------------------------------------

*   Add Kount order fraud card in admin

    Add order fraud card to the order admin exposing the score, number of
    cards, email addresses, devices and rules triggered.

    KOUNT-33
    Eric Pigeon



Workarea Kount 3.0.1 (2018-12-11)
--------------------------------------------------------------------------------

*   Index orders under kount review in the admin

    Fixes a bug where orders that were placed under review by kount during
    order place weren't being made available in the admin search.

    KOUNT-32
    Eric Pigeon



Workarea Kount 3.0.0 (2018-10-02)
--------------------------------------------------------------------------------

*   Kount Pre-Authorization

    Integration kount pre authorization.  Before the credit card or payment
    is authorized a request to kount is made.  If kount approved checkout
    continues as normal.  If kount declines an error message is show to the
    user.  If kount makes as review the end user is show the order as if it
    is placed but no authorization happens.  An admin will have to appove or
    decline the order in kount admin, to place the order or cancel the order
    out.  See the README for more details.

    KOUNT-26
    Eric Pigeon



Workarea Kount 2.0.1 (2018-03-21)
--------------------------------------------------------------------------------

*   Update code to not be dependent on paypal or plugin giftcards

    instead of checking the class of the tender use the tender slug it
    doesn't create a dependency on the Tender::Paypal or Tender::GiftCard
    constants.

    KOUNT-20
    Eric Pigeon

*   Append data collector to the top of checkout payment

    KOUNT-21
    Dave Barnow

*   KOUNT-16: Stop Collector iFrame from displaying on payment step
    Jordan Stewart

*   KOUNT-13: Update payment type for Store Credit
    Bryan Alexander


Workarea Kount 2.0.0 (2017-09-07)
--------------------------------------------------------------------------------

*   Clean up Kount test suite

    stop test suite from using the sandbox gateway outside of tests using
    VCR.  Clean up some unused test methods leftover from the upgrade.  Use
    Workarea::TestCase where appropriate.

    KOUNT-11
    Eric Pigeon

*   * Use time travel to aid asserting card number encryption
    * Configure sandbox credentials for minitest

    KOUNT-8
    Jake Beresford

*   * Move kount_priorities onto Workarea::Kount.config
    * Reverse naming and logic for worker_enabled to worker_disabled
    * Update readme

    KOUNT-8
    Jake Beresford

*   Upgrade for v3 compatability

    * remove listener, add sidekiq worker enqueue_on instead
    * Rename to workarea and storefront, bump dependencies, Add dotfiles for linting etc., Update rakefile for v3 and add changelog task, Update decorator syntax, Convert rspec to minitest
    * update shipping_method to shipping_service
    * update references to order.number to use order.id
    * Add paypal and giftcard gems to testing env and test these integrations conditionally
    * Send StoreCredit tender as 'OTHER' Kount PaymentType

    KOUNT-8
    Jake Beresford
