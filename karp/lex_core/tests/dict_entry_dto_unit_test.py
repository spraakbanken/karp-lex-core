from karp.lex_core.dtos import EntryDtoDict


def test_can_create_entry_dto():
    entry_dto = EntryDtoDict(entry={"field": "value"})
