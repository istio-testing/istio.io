---
title: Announcing Istio 1.15.6
linktitle: 1.15.6
subtitle: Patch Release
description: Istio 1.15.6 patch release.
publishdate: 2023-02-21
release: 1.15.6
aliases:
    - /news/announcing-1.15.6
---

This release contains bug fixes to improve robustness. This release note describes what’s different between Istio 1.15.5 and Istio 1.15.6.

This release includes security fixes in Go 1.19.6 (released 2/14/2023) for the `path/filepath`, `net/http`, `mime/multipart`, and `crypto/tls` packages.

{{< relnote >}}

## Changes

- The only change in this release is the Golang security update.