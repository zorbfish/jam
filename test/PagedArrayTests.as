class PagedArrayTests extends leanUnit.TestCase {

  function test_when_page_less_than_fixed_page_length_array_resized() {
    var PAGE_LENGTH = 3
    var sample = new Array("a", "b", "c", "d")
    var pager = new PagedArray(PAGE_LENGTH, sample)
    var result = []

    pager.next_page(result)

    assertEqual(result, ["d"])
  }
}
