grails.project.class.dir = "target/classes"
grails.project.test.class.dir = "target/test-classes"
grails.project.test.reports.dir = "target/test-reports"
grails.project.target.level = 1.6

grails.project.fork = [
    //  compile: [maxMemory: 256, minMemory: 64, debug: false, maxPerm: 256, daemon:true],
    test: [maxMemory: 768, minMemory: 64, debug: false, maxPerm: 256, forkReserve:false],
    run: [maxMemory: 768, minMemory: 64, debug: false, maxPerm: 256, forkReserve:false],
    war: [maxMemory: 768, minMemory: 64, debug: false, maxPerm: 256, forkReserve:false],
    console: [maxMemory: 768, minMemory: 64, debug: false, maxPerm: 256]
]

grails.project.dependency.resolver = "maven"
grails.project.dependency.resolution = {
    inherits("global") {}
    log "warn"
    legacyResolve false
    repositories {
        grailsCentral()
        //mavenRepo "http://labs.technipelago.se/repo/crm-releases-local/"
        mavenLocal()
        mavenRepo "http://labs.technipelago.se/repo/plugins-releases-local/"
        mavenCentral()
    }
    dependencies {
    }

    plugins {
        build(":release:3.1.2",
                ":rest-client-builder:2.1.1") {
            export = false
        }
        test(":hibernate4:4.3.6.1") {
            excludes "net.sf.ehcache:ehcache-core"  // remove this when http://jira.grails.org/browse/GPHIB-18 is resolved
            export = false
        }

        test(":codenarc:0.25.2") { export = false }
        test(":code-coverage:2.0.3-3") { export = false }

        compile ":selection:0.9.9"
        compile ":selection-repository:0.9.3"
        compile ":ckeditor:4.5.4.0"

        compile ":crm-blog:2.4.2"
        compile ":crm-ui-bootstrap:2.4.4"
    }
}

codenarc.reports = {
    xmlReport('xml') {
        outputFile = 'target/CodeNarcReport.xml'
    }
    htmlReport('html') {
        outputFile = 'target/CodeNarcReport.html'
    }
}
