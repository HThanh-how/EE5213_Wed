import logging
import json
import uuid
from datetime import datetime, timezone

class EnterpriseJSONFormatter(logging.Formatter):
    def format(self, record: logging.LogRecord) -> str:
        log_obj = {
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "level": record.levelname,
            "message": record.getMessage(),
            "trace_id": getattr(record, "trace_id", "N/A"),
            "context": getattr(record, "context", {})
        }
        if record.exc_info:
            log_obj["errors"] = self.formatException(record.exc_info)
        return json.dumps(log_obj)

def get_logger(name="CTL_Engine"):
    logger = logging.getLogger(name)
    if not logger.handlers:
        logger.setLevel(logging.DEBUG)
        handler = logging.StreamHandler()
        handler.setFormatter(EnterpriseJSONFormatter())
        logger.addHandler(handler)
    return logger
