# Crawler

[![Build Status](https://travis-ci.org/ngauthier/crawler.svg?branch=master)](https://travis-ci.org/ngauthier/crawler)

A simple web crawler that traverses and stores all links on a target domain.

## Goals

* It should be limited to one domain
* It will not follow external links
* It will not follow subdomain links
* Given a URL it should output a site map
* Site map should show which static assets each page depends on
* Site map should show links between pages
* Focus on code quality and write tests

## Usage

    crawler http://ngauthier.com

## Output

An extended adjacency list in JSON. Top level object is an array, each child is an object representing a page. The Page has an array of asset urls, as well as an array of links:

    [
      {
        url: "http://ngauthier.com",
        assets: [
          "http://ngauthier.com/css/ngauthier.css",
          "..."
        ],
        links: [
          "http://ngauthier.com/2014/06/scraping-the-web-with-ruby.html"
        ]
      }
      // ...
    ]

## Assumptions made

1. To keep the solution small and simple, do work locally, not with a larger database
1. Not going to do a full distributed cloud based solution until we need to crawl enormous sites
1. Half of the solution should be extensible to a distributed solution (the crawling part) and the storage and workers should be sufficiently decoupled to allow a pivot to a cloud based solution with minimal discomfort

## Looking ahead: edge cases and potential issues

1. Cycle detection
1. Question of anchors in urls, request parameters, etc
1. Performance and resilience (resumable or persistent?)
1. Multi threading optimization
1. Back end for page fetching: ruby lib or libcurl or net/http
1. Depth first or breadth first?
1. Respect robots.txt? Maybe not for this exercise, but it is a concern to note


## Testing style and plan

1. Highest level: fixture sites we can crawl locally for performance and dependability
1. Integration: subset of tests to crawl real sites. Less assertions but looking for it to work on a real site. Maybe snapshot a simple site, like my blog, and compare?
1. Unit level: test getting individual page, individual link parsing and handling, potentially the queue or stack used for working on the site as a whole, handling common crashes (like failed to fetch a page or parse html)

## Plan of attack

Use the gdbm, domino, json, AR-style pattern from the blog post, but augmented to do a recursive crawl (well, not really, probably queue-based)

### Initial solution

1. Fetch a single page, output its links and assets, store in gdbm, output to json
1. Push all the pages links back into the db (if they don't exist) and mark the page as crawled
1. Loop on the gdbm list of pages and work on the first one not crawled

### Extensions

1. Worker pool, locking (with time-based expiration), supervisor to kill stale workers and unlock pages that have been locked beyond the timeout
1. Redis backed for distributed processing
1. Cloud-based solution to allow for multiple workers
