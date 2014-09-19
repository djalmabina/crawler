# Crawler

[![Build Status](https://travis-ci.org/ngauthier/crawler.svg?branch=master)](https://travis-ci.org/ngauthier/crawler)

A simple web crawler that traverses and stores all links on a target domain.

## Goals

- [x] It should be limited to one domain
- [x] It will not follow external links
- [x] It will not follow subdomain links
- [x] Given a URL it should output a site map
- [x] Site map should show which static assets each page depends on
- [x] Site map should show links between pages
- [x] Focus on code quality and write tests
- [ ] Executable to use on the cli
- [ ] Integration test on a real page
- [ ] Output as yaml, json, xml
- [ ] Does not follow cycles
- [ ] Resumable
- [ ] Progress indicator

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

1. To keep the solution small and simple, do work locally, not with a database process
1. Not going to do a full distributed cloud based solution until we need to crawl enormous sites
1. Half of the solution should be extensible to a distributed solution (the crawling part) and the storage and workers should be sufficiently decoupled to allow a pivot to a cloud based solution with minimal discomfort
1. Assets are `style`, `link`, and `img` tags with external paths. Inlined CSS and JS will not be included as they are not an external file (that would need to be fetched). It should be simple to add more tags to store.
