foreach(exec basic_device_io create_device_context query_platforms_devices sum
             clfortran_hl)
  add_executable(test_${exec} test_${exec}.f90)
  target_link_libraries(test_${exec} PUBLIC clfortran)
  add_test(NAME test_${exec} COMMAND $<TARGET_FILE:test_${exec}>)

  # set_tests_properties(test_${exec} PROPERTIES RUN_SERIAL TRUE)
endforeach()
