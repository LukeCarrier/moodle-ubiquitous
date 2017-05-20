# Using Ubiquitous in production

In a production environment, you would deploy Ubiquitous to an IaaS provider such as [AWS](https://aws.amazon.com/) or [Azure](https://azure.microsoft.com/), preferably using an inventory management tool such as [Terraform](https://www.terraform.io/) to manage the machines.

## Preparing a new environment

Before proceeding, make sure you a basic understanding of the different [Ubiquitous roles](../roles/).

1. Prepare a new server (see below)
2. [Install a Salt master](../roles/salt.md#installing-the-master)

## Preparing new servers

All servers in the cluster will be configured as Salt minions. Salt will handle configuring the servers based on roles which we'll assign later -- see the subheadings. This section assumes a stock, minimal installation of Ubuntu 16.04.2 LTS with networking correctly configured.

1. [Install the Salt minion](../roles/salt.md#installing-minions)
2. [Assign the appropriate role](../roles/salt.md#assigning-roles-to-minions)
3. [Apply states](../roles/salt.md#applying-states)
