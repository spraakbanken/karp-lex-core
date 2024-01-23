from datetime import datetime  # noqa: D100
from typing import Generic, Optional, TypeVar

from karp.lex_core import alias_generators
from karp.lex_core.value_objects import UniqueIdStr
from pydantic import model_validator, BaseModel, ConfigDict

T = TypeVar("T")


class GenericEntryDto(BaseModel, Generic[T]):  # noqa: D101
    entry: T
    last_modified_by: Optional[str] = None
    last_modified: Optional[datetime] = None
    id: Optional[UniqueIdStr] = None  # noqa: A003
    version: Optional[int] = None
    resource: Optional[str] = None
    message: Optional[str] = None
    discarded: bool = False
    model_config = ConfigDict(alias_generator=alias_generators.to_lower_camel)

    @model_validator(mode="before")
    @classmethod
    def allow_snake_case(cls, values):  # noqa: ANN206, D102, ANN001
        if "last_modified" in values:
            values["lastModified"] = values.pop("last_modified")
        if "last_modified_by" in values:
            values["lastModifiedBy"] = values.pop("last_modified_by")
        if "entity_id" in values:
            values["entityId"] = values.pop("entity_id")
        return values

    def serialize(self):  # noqa: ANN201, D102
        return self.model_dump(by_alias=True, exclude_none=True)


class EntryDto(GenericEntryDto[dict]):  # noqa: D101
    ...
