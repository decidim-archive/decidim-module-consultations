# decidim-module-consultations

In 2018, this module was integrated into the main repository: [decidim/decidim](https://github.com/decidim/decidim).

In 2021, we started developing an alternative module called `decidim-elections` and initiated the deprecation process for the original module. We added a callout in the admin panel for this module:

>  Consultations module will be deprecated in the near future. We’re working on the next cryptographically secure version called Votings.  

In 2023, as part of the Redesign process, we removed the code for this module from the main repository. Please refer to PR [#11171](https://github.com/decidim/decidim/pull/11171) for more details.

If you wish to maintain a new version of this module, you can recover it using git:

```shell
git clone https://github.com/decidim/decidim
git restore -s c58b304bef442df8e749e124ad9f43fd9b9dbc68 decidim-consultations
```

If you're maintaining a version of this module, please share the URL of the git repository by [creating an issue on the decidim.org website repository](https://github.com/decidim/decidim.org) so that we can update the [Modules page](https://decidim.org/modules).
