import com.twitter.conversions.storage._
import com.twitter.conversions.time._
import com.twitter.logging.config._
import com.twitter.ostrich.admin.config._
import net.lag.kestrel.config._

new KestrelConfig {
  listenAddress = "0.0.0.0"
  memcacheListenPort = 22133
  textListenPort = 2222
  thriftListenPort = 2229

  queuePath = "/tmp/kestrel-queue"

  clientTimeout = 30.seconds

  expirationTimerFrequency = 1.second

  maxOpenTransactions = 100

  // default queue settings:
  default.defaultJournalSize = 16.megabytes
  default.maxMemorySize = 128.megabytes
  default.maxJournalSize = 1.gigabyte
  default.maxItems = 0

  admin.httpPort = 2223

  admin.statsNodes = new StatsConfig {
    reporters = new TimeSeriesCollectorConfig
  }

  queues = new QueueBuilder {
    name = "transient_events"
    keepJournal = false
  } :: new QueueBuilder {
    name = "services"
    // Timeout for the descriptors
    maxAge = 100.seconds
    maxItems = 1500000
    keepJournal = false   //afegit 25april
  } :: new QueueBuilder {
    name = "actions"
    // Timeout for the descriptors
    maxAge = 300.seconds
    maxItems = 1500000
    keepJournal = false
  } :: new QueueBuilder {
    name = "reputation"
    // Timeout for the descriptors
    maxAge = 300.seconds
    maxItems = 1500000
    keepJournal = false
  }

  loggers = new LoggerConfig {
    level = Level.INFO
    //level = Level.DEBUG
    handlers = new FileHandlerConfig {
      filename = "/tmp/kestrel.log"
      roll = Policy.Never
    }
  }

}
