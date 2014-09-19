# Crawler

[![Build Status](https://travis-ci.org/ngauthier/crawler.svg?branch=master)](https://travis-ci.org/ngauthier/crawler)

A simple web crawler that traverses and stores all links on a target domain.

## Usage

The project is packaged as a gem but not pushed to rubygems. Clone the repository, `bundle`, then run the crawler executable (in the bin directory):

    crawler http://ngauthier.com

Logging will be displayed via standard error. The JSON output will be done at the end via standard out.

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

## Behavior

- Restricted to a single domain
- Does not follow external links
- Does not follow subdomain links
- Given a starting url it outputs a sitemap (in JSON, see above)
- Site map shows what assets a page depends on
- Site map shows links between pages
- Does not follow cycles
- Resumable (see Resuming and Storage section)
- Logging via stderr
- Output via stdout

## Resuming and Storage

The process is fully resumable. If you kill it or it crashes, it can be re-run and it will pick up where it left off. It uses GDBM as a key value store, using urls as the keys and the value is the json document for a single page. This file will be in the current directory and named after the domain. For example, while crawling `example.com` there will be a GDBM file called `example.com.db` in the current directory.

## Testing

From the start the project was test-driven and coverage was measured via simplecov. Coverage was required to be at 100% or the build would fail. In a few cases tests were written after the code when the code being written was exploratory. After the test covered the exploratory code the code was refactored under test until it was acceptable.

The only uncovered line of code is the executable itself, `bin/crawler`, but that is a simple delegation to the `Crawler.cli` method, which is fully tested.

## Unix and Ruby Conventions

The library conforms to both Unix and Ruby standards. The executable uses standard out and standard error so that it can be piped to a file for both logging and output.

On the ruby side, the library is very accessible, so crawling can be initiated or even manually iterated by another library. The GDBM storage backend is pluggable simply by implementing a new storage driver that is similar to `crawler/gdbm_store` and using that as the base class for a new kind of result object.

## Standard Library and General Minimalism

The standard library was used for as much as possible. Testing is via Minitest, Logging via logger, OpenURI for page fetching, and GDBM for storage. The only production dependency for this project is Nokogiri for document parsing. In general the code is minimal and simple for ease of development and resilience. As of this edit, there are less than 200 lines of code in the project.

## Assumptions made

1. Not going to do a full distributed cloud based solution until we need to crawl enormous sites (simple until proven slow)
1. Assets are `style`, `link`, and `img` tags with external paths. Inlined CSS and JS will not be included as they are not an external file (that would need to be fetched). It should be simple to add more tags to store.
1. I did not trim off trailing slashes. I decided that if a site references a page with and without a slash that I would recognize that. Especially since removing the slash is a destructive action which does not retain the fact that the link had a slash. So a further scrape of that page would find a link that didn't match one in our db. Simply put: you said it's different so I'll respect that.
