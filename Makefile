TARGET_DIR=build
TARGET=$(TARGET_DIR)/distortion
FAUST_CMD=faust2jack
FAUST_SRC=distortion.dsp

$(TARGET): $(FAUST_SRC)
	mkdir -p $(TARGET_DIR)
	$(FAUST_CMD) $^ -o $(TARGET)
	# TODO for some reason, faust2jack ignores the output file directory
	mv $(@F) $(TARGET_DIR)

run: $(TARGET)
	./$(TARGET)

clean:
	-rm -rf $(TARGET_DIR)
