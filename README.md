# Workarea Kount

A plugin for integrating the [Kount](https://kount.com) fraudulent order
detection service with the [Workarea](https://workarea.com) commerce
platform.

## Getting Started

First, add the gem to your bundle:

```ruby
gem 'workarea-kount'
```

Then, run:

```bash
$ bundle
```

## Configuration

Add values for `merchant_id`, `version`, `key`, and `ksalt` to your
application secrets:

```yaml
kount:
  merchant_id: (all of the following is obtained from Kount)
  version:
  key:
  ksalt:
  ens_username: username for basic auth for ENS
  ens_password: password for basic auth for ENS
  kount_site: <site name for ENS>
```

### Event Notification System Configuration

The Kount ENS requires configuration in Workarea to match configuration in Kount.
If the ENS is not configured properly, Kount review decisions will not be
received by Workarea.

Workarea uses basic auth credentials `ens_username:ens_password` to authenticate
requests from the Kount ENS. If your application is behind basic_auth (e.g. in
staging or QA) you should configure these credentials to match your basic auth
credentials for the environment. If your application is not behind basic auth
these credentials can be anything you want, as long as they are secure.

#### Kount Site

The `kount_site` configuration is used by kount ENS to determine which endpoint
events should be sent to. If no `kount_site` is provided the DEFAULT site will
be used. `kount_site` can be used to configure different ENS endpoints for
testing inQA and Staging, or for multi-site implementations.

#### Configure ENS in Kount

In the Kount admin navigate to: `Fraud Control` -> `Websites` -> `Add Website`

The ENS Api URL should look like `https://ENS_USERNAME:ENS_PASSWORD@WEBSITE_DOMAIN/kount_orders`

Example: `https://kount:aksjei8243d8@www.example.com/kount_orders`

## Usage

Kount works with Workarea's `FraudDecision` API. When configured, this
plugin will automatically send orders to Kount to determine whether they
are fraudulent.

### Response Codes

Kount's Risk Inquiry Services will return one of the following values:

* **Approved** - the order is not suspected as fraudulent
* **Decline** - the order is fraudulent
* **Review** - the order is suspected to be fraudulent

### Order Flow

Before payment is captured, this plugin will send credit card and PayPal
orders to Kount upon order placement. Based on the response from Kount,
one of the following actions will be taken:

#### Approved - The order is not fraudulent

The order is placed.

#### Decline - The order is fraudulent

An error is shown to the customer and redirected back to the payment step.

#### Hold for manager review - the order is suspected fraudulent

The credit card is tokenized and inventory is captured but the payment is not
authorized/purchased. The customer is shown the order confirmation as if the
order is placed. A Kount admin user needs to use approve or decline the order
via the Kount admin. This order will also be available to view in the
Workarea admin.

The Kount Event Notificaion System (ENS) will post the data back to Workarea.

If the admin declines the order in Kount, the order is canceled and the customer
recieves a cancelation email.

If the admin approves the order, the payment is attemped to be captured. If the
payment captures successfully the order is placed.  If the payment fails
authorization/purchase, the order is canceled and the customer recives a
cancelation email.

## Workarea Platform Documentation

See [http://developer.workarea.com](http://developer.workarea.com) for Workarea
platform documentation.

## Copyright & Licensing

Copyright WebLinc 2018. All rights reserved.

For licensing, contact sales@weblinc.com.
